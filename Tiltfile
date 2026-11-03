load('ext://git_resource', 'git_checkout')

git_checkout('https://github.com/lftraining/LFS241.git', './tmp/')

# Cloudflare Gateway intercepts TLS, so the Go builder needs to trust its CA to reach proxy.golang.org.
# Inject it via a BuildKit secret rather than modifying the upstream Dockerfile.
CA_CERT = os.getenv('HOME') + '/.docker/certs.d/CloudFlareManagedG2.pem'
demo_dockerfile = str(read_file('./tmp/demo-service-source/Dockerfile')).replace(
    'RUN go mod download',
    'RUN --mount=type=secret,id=ca_cert cat /run/secrets/ca_cert >> /etc/ssl/certs/ca-certificates.crt && go mod download',
)

docker_build(
    'demo',
    './tmp/demo-service-source/',
    dockerfile_contents=demo_dockerfile,
    secret='id=ca_cert,src=' + CA_CERT,
)

docker_compose("./docker-compose.yml")
