from locust import HttpLocust, TaskSet, task, between
from locust import HttpUser


class LDAPMAN_API_TESTER(HttpUser):
    wait_time = between(2, 6)
    token = ''
    headers = {}

    def on_start(self):
        self.login()

    def on_stop(self):
        print("stop tester")

    def login(self):
        r = self.client.post('/api/token', {'username': 'zhangpeng', 'password': 'zhangpeng'})
        print(r.status_code)
        if r.status_code == 200:
            response_data = r.json()
            self.token = response_data['access_token']
            self.headers['Authorization'] = f'Bearer {self.token}'
        else:
            pass

    @task()
    def test_menu(self):
        self.client.get('/api/util/menu', headers=self.headers)

    @task()
    def test_users(self):
        self.client.get('/api/users/', headers=self.headers)

    @task()
    def test_groups(self):
        self.client.get('/api/groups/', headers=self.headers)

    @task()
    def test_maillist(self):
        self.client.get('/api/maillists/', headers=self.headers)

    @task()
    def get_api_maillist_all_group_member(l):
        l.client.get('/api/maillists/all_group/member', headers=l.headers)

    @task()
    def get_api_maillist_devops_group_member(l):
        l.client.get('/api/maillists/devops_group/member', headers=l.headers)


