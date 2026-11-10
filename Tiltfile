load('ext://git_resource', 'git_checkout')

git_checkout('https://github.com/lftraining/LFS241.git', './tmp/')

# Cloudflare Gateway intercepts TLS, so builds need to trust its CA to reach proxy.golang.org etc.
# ca_docker_build injects it via a BuildKit secret before the first RUN of every build stage,
# so upstream Dockerfiles work unmodified. Stages without a RUN (e.g. scratch/distroless) are left alone.
CA_CERT = os.getenv('HOME') + '/.docker/certs.d/CloudFlareManagedG2.pem'
CA_INJECT = 'RUN --mount=type=secret,id=ca_cert mkdir -p /etc/ssl/certs && cat /run/secrets/ca_cert >> /etc/ssl/certs/ca-certificates.crt'

def with_ca_cert(dockerfile_contents):
    lines = []
    needs_cert = False
    for line in dockerfile_contents.splitlines():
        instruction = line.strip().upper()
        if instruction.startswith('FROM '):
            needs_cert = True
        elif needs_cert and instruction.startswith('RUN '):
            lines.append(CA_INJECT)
            needs_cert = False
        lines.append(line)
    return '\n'.join(lines) + '\n'

def ca_docker_build(ref, context, dockerfile_contents=None, **kwargs):
    if dockerfile_contents == None:
        dockerfile_contents = str(read_file(context + '/Dockerfile'))
    docker_build(
        ref,
        context,
        dockerfile_contents=with_ca_cert(dockerfile_contents),
        secret='id=ca_cert,src=' + CA_CERT,
        **kwargs
    )

ca_docker_build('demo', './tmp/demo-service-source/')

# Upstream doesn't pin client_golang, and the latest release requires Go >= 1.26.
# Build from the repo root so the local main.go is used (and watched) instead of upstream's.
ca_docker_build(
    'lab-app',
    '.',
    dockerfile_contents=str(read_file('./tmp/instrumentation-exercise/go/Dockerfile'))
      .replace('golang:1.24', 'golang:1.26'),
    only=['./main.go'],
)

docker_compose("./docker-compose.yml")

