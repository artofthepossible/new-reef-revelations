import pytest
from testcontainers.core.container import DockerContainer
from testcontainers.core.waiting_utils import wait_for_logs
from flask.testing import FlaskClient
from app import app
import requests
import datetime

@pytest.fixture(scope="session")
def flask_app():
    """Fixture that provides a Flask test client"""
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

@pytest.fixture(scope="session", autouse=True)
def metadata(request):
    """Fixture to provide test metadata for reporting"""
    request.config._metadata = {
        'Project Name': 'Docker Scout Demo',
        'Tested Application': 'Flask Web App',
        'Test Framework': 'pytest + testcontainers',
'Container Image': 'python:3.9',
        'Timestamp': datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    }

@pytest.fixture(scope="session")
def flask_container():
    """
    Testcontainers fixture that:
    1. Creates a Python container
    2. Exposes port 8080
    3. Mounts application code
    4. Runs Flask application
    5. Waits for container readiness
    """
    container = DockerContainer("python:3.9")
    container.with_exposed_ports(8080)
    container.with_volume_mapping(".", "/app")
    container.with_command("python /app/app.py")
    
    with container as c:
# Validate container is running and app is ready
        wait_for_logs(c, "Running on http://0.0.0.0:8080")
        yield c

def test_home_page_detailed(flask_app: FlaskClient):
    """Detailed test of homepage content and structure"""
    response = flask_app.get('/')
    assert response.status_code == 200, "Homepage should return 200 OK"
    content = response.data.decode()
    
    # Test required elements
    assert '<html lang="en">' in content, "HTML lang attribute should be present"
    assert '<title>Docker Scout Demo</title>' in content, "Title should be present"
    assert 'Welcome to the Docker Scout Demo' in content, "Welcome message should be present"

def test_links_functionality(flask_app: FlaskClient):
    """Test all navigation links are present and properly formatted"""
    response = flask_app.get('/')
    content = response.data.decode()
    
    expected_links = [
        ('Docker Scout Quickstart', 'https://docs.docker.com/scout/quickstart/'),
        ('Docker Scout Demo', 'https://github.com/docker/scout-demo-service'),
        ('Get Started with Docker Scout Today', 'https://scout.docker.com/org/demonstrationorg/guided-setup')
    ]
    
    for text, url in expected_links:
        assert f'href="{url}"' in content, f"Link to {text} should be present"
        assert text in content, f"Link text '{text}' should be present"

def test_static_assets(flask_app: FlaskClient):
    """Test static assets are properly served"""
    response = flask_app.get('/static/futuristic-world-docker-whale.jpg')
    assert response.status_code == 200, "Static image should be accessible"
    assert response.headers['Content-Type'].startswith('image/'), "Should return image content type"