class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "0ebf856b54fa217b678cef1dcbd41ca9195141682132b55dac2b55e4b62edf49"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a764ce74160544a8360803a778ce7edc6865e397d17ced9fd93df040ae6eb84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a764ce74160544a8360803a778ce7edc6865e397d17ced9fd93df040ae6eb84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a764ce74160544a8360803a778ce7edc6865e397d17ced9fd93df040ae6eb84"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b63d222dd8dfa25969984d88b55394fe3d7a60f5b18ea70443f13049a02bdd56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e40ee4df8f57d0dc16236b76c704757ddefba118ee8f28a00424cdcb21d3e815"
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
