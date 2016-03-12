class TiyoScraper
  def initialize email:, password:
     @agent = Mechanize.new
     @agent.get "https://online.theironyard.com" do |page|
       page.form_with action: "/users/sign_in" do |form|
         form["user[email]"]    = email
         form["user[password]"] = password
       end.click_button
     end
  end

  def run!
    pull_campuses
    staff_data.each { |data| sync_staff_member data }
  end

  def pull_campuses
    response = get "campuses.json"
    parsed   = JSON.parse response.body
    raise "Need to page through campuses now" if parsed.keys != ["campuses"]

    parsed["campuses"].each do |data|
      campus = Campus.where(tiyo_id: data.fetch("id")).first_or_initialize
      campus.name = data.fetch("title")
      campus.save!

      data["cohorts"].each do |cohort_data|
        cohort = Cohort.where(tiyo_id: cohort_data.fetch("id")).first_or_initialize
        cohort.title = cohort_data.fetch "title"
        cohort.campus_id = campus.id
        cohort.save!
      end
    end
  end

  def staff_data
    return @_users if @_users
    page = staff_page 1
    @_users = page["users"]
    2.upto page["meta"]["totalPages"] do |i|
      @_users += staff_page(i)["users"]
    end
    @_users
  end

  def staff_page n
    response = get "users.json?admins=%E2%9C%93&page=#{n}"
    JSON.parse response.body
  end

  def sync_staff_member data
    y = Yardigan.where(email: data.fetch("email")).first_or_initialize
    y.tiyo_id = data.fetch "id"
    y.name    = data.fetch "name"
    y.save!

    data["cohorts"].each { |cohort| attach_cohort y, cohort }
  end

  def attach_cohort y, cd
    cohort = Cohort.find_by! tiyo_id: cd.fetch("id")
    refresh_cohort cohort unless cohort.start_on && cohort.end_on
    y.attach_cohort cohort
  end

  def campuses_by_name
    @_campuses_by_name ||= Campus.all.map { |c| [c.name, c] }.to_h
  end

  def refresh_cohort cohort
    page = get "cohorts/#{cohort.tiyo_id}"

    if campus = find(header: "Campus", page: page, lookup: campuses_by_name)
      cohort.campus = campus
    else
      raise "Could not find campus for cohort" unless campus
    end

    date_rexp = /\d{4}-\d{2}-\d{2}/
    cohort.start_on = find header: "Start Date", page: page, regex: date_rexp
    cohort.end_on   = find header: "End Date",   page: page, regex: date_rexp
    cohort.save!
  end

  def find page:, header:, lookup: nil, regex: nil
    raise "Must specify finder" unless lookup || regex

    results = Set.new
    page.root.traverse do |node|
      next unless node.respond_to?(:content)
      text = node.content.strip
      next unless text.start_with? header

      hits = if lookup
        lookup.select { |title, _| text.include?(title) }.values
      elsif regex
        text.scan regex
      end
      results.merge hits if hits.length == 1
    end

    unless results.count < 2
      raise "Found multiples: #{header} - #{results.to_a}"
    end
    results.first
  end

  private

  def get url, *args
    @agent.get "https://online.theironyard.com/admin/#{url}", args
  end
end
