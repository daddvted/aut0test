from selenium.webdriver import Chrome
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys

driver = Chrome()


driver.get("https://www.baidu.com")
input_element = driver.find_element(By.ID, "kw")
input_element.send_keys("shit")
input_element.send_keys(Keys.ENTER)