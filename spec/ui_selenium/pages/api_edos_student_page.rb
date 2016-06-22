class ApiEdosStudentPage

  include PageObject
  include ClassLogger

  def get_json(driver)
    logger.info 'Parsing JSON from /api/edos/student'
    navigate_to "#{WebDriverUtils.base_url}/api/edos/student"
    wait_until(WebDriverUtils.page_load_timeout) { driver.find_element(:xpath, '//pre[contains(.,"statusCode")]') }
    @parsed = JSON.parse driver.find_element(:xpath, '//pre').text
  end

  def feed
    @parsed['feed']
  end

  def student
    feed['student']
  end

  def residency
    student['residency']
  end

  def residency_official
    residency && residency['official']
  end

  def residency_desc
    residency_official['description'].blank? ? 'Not Yet Submitted' : residency_official['description']
  end

  def residency_from_term
    residency && residency['fromTerm']['label']
  end

  def residency_message_code
    residency && residency['message']['code']
  end

  def has_residency?
    true unless residency.nil? || residency.empty?
  end

  def affiliations
    student['affiliations']
  end

  def affiliation_types
    affiliations ? (affiliations.map { |affiliation| affiliation['type']['code'] }) : []
  end

end
