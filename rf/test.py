import time
from selenium import webdriver

browser = webdriver.Chrome()
#browser = webdriver.Firefox()

browser.get('http://www.baidu.com')

time.sleep(10)

browser.quit()