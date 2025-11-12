class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "e6fadb8c599591e200b2322c45309e8fed4c382c721953285af548c41a62adc2"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b01f33ed512865de74550b2ef0ebaa39903a7e0de01af5ba52d7a52247c8c70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b01f33ed512865de74550b2ef0ebaa39903a7e0de01af5ba52d7a52247c8c70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b01f33ed512865de74550b2ef0ebaa39903a7e0de01af5ba52d7a52247c8c70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5088148ffbcd24cb1f38e0620207b615fac2b80ccaed561c27d2b04dfe64c9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7263fb97354660c86f19904e837e3bd7b0a5515dae21a134358a530e28ed5116"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/resterm"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/resterm -version")

    (testpath/"openapi.yml").write <<~YAML
      openapi: 3.0.0
      info:
        title: Test API
        version: 1.0.0
        description: A simple test API
      servers:
        - url: https://api.example.com
          description: Production server
      paths:
        /ping:
          get:
            summary: Ping endpoint
            operationId: ping
            responses:
              "200":
                description: Successful response
                content:
                  application/json:
                    schema:
                      type: object
                      properties:
                        message:
                          type: string
                          example: "pong"
      components:
        schemas:
          PingResponse:
            type: object
            properties:
              message:
                type: string
    YAML

    system bin/"resterm", "--from-openapi", testpath/"openapi.yml",
                          "--http-out",     testpath/"out.http",
                          "--openapi-base-var", "apiBase",
                          "--openapi-server-index", "0"

    assert_match "GET {{apiBase}}/ping", (testpath/"out.http").read
  end
end
