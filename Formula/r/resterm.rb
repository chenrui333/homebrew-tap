class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "1b0241ea823d69d99d51c06c8c5229db0dc635775a6a6df3dee779ec3da476fd"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cec76100edd6b1448dff479b89a7369bb74a4e724a1c88b92ffdc2739ae91b08"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cec76100edd6b1448dff479b89a7369bb74a4e724a1c88b92ffdc2739ae91b08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cec76100edd6b1448dff479b89a7369bb74a4e724a1c88b92ffdc2739ae91b08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a29e6ccb6bd4a4b3694403bba1aae43cc2bbe794a69ddfe6bf320d1d7003e1f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7bbdd7dff5b57410a5499a071d77a6f2e489d1e1873c511e514449ba090008e"
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
