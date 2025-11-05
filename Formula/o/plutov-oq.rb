class PlutovOq < Formula
  desc "Terminal OpenAPI Spec viewer"
  homepage "https://github.com/plutov/oq"
  url "https://github.com/plutov/oq/archive/refs/tags/v0.0.20.tar.gz"
  sha256 "e6643bbe9aa139ea02c1733bb2b1a9baeccfe7abd1bad7bd83eeced13b48f6b0"
  license "MIT"
  head "https://github.com/plutov/oq.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"oq")
  end

  # test do
  #   # Test with a simple OpenAPI spec
  #   (testpath/"openapi.yaml").write <<~EOS
  #     openapi: 3.0.0
  #     info:
  #       title: Sample API
  #       version: 0.1.0
  #     paths:
  #       /hello:
  #         get:
  #           summary: Returns a greeting message
  #           responses:
  #             '200':
  #               description: A successful response
  #               content:
  #                 application/json:
  #                   schema:
  #                     type: object
  #                     properties:
  #                       message:
  #                         type: string
  #   EOS

  #   # Try different command formats that might work
  #   output = shell_output("#{bin}/oq #{testpath}/openapi.yaml", 0)
  #   assert_match "Sample API", output
  # end
end
