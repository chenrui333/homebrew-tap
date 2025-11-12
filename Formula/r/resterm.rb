class Resterm < Formula
  desc "Terminal client for .http/.rest files with HTTP, GraphQL, and gRPC support"
  homepage "https://github.com/unkn0wn-root/resterm"
  url "https://github.com/unkn0wn-root/resterm/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "e6fadb8c599591e200b2322c45309e8fed4c382c721953285af548c41a62adc2"
  license "Apache-2.0"
  head "https://github.com/unkn0wn-root/resterm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "968723c8927fd974acc80a9c516e29c9accec596f468376f81f8ac058d2f1cd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "968723c8927fd974acc80a9c516e29c9accec596f468376f81f8ac058d2f1cd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "968723c8927fd974acc80a9c516e29c9accec596f468376f81f8ac058d2f1cd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb448cbbef7bc42e52a1d85db4324296cf02a8b0ad85e2820269e75a5224ca62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ae22265ec51475053be84d1f0b8aa8f685d95273e09f6694e2789d7f525959a"
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
