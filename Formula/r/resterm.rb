class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "f59cfdd922a431c0af76d337c768bb56b19a7d511f2f4a17c55b917523f2f857"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7fa66bb8ecab8424c2ef6f62fb8feded0e78527e87e08bdb2c09358f67ac8a07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fa66bb8ecab8424c2ef6f62fb8feded0e78527e87e08bdb2c09358f67ac8a07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fa66bb8ecab8424c2ef6f62fb8feded0e78527e87e08bdb2c09358f67ac8a07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d83ba3068e7ca4d872d307fc6d2bf35e1c5c69cb69f596879d11a9ea6030e639"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98d9d450cb1f6da6f122cd5e75804f134ef80ff9598b2ad1bb1960ad5ef9ac4d"
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
