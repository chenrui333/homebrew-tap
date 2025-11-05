class PlutovOq < Formula
  desc "Terminal OpenAPI Spec viewer"
  homepage "https://github.com/plutov/oq"
  url "https://github.com/plutov/oq/archive/refs/tags/v0.0.22.tar.gz"
  sha256 "4b4b3f294482bdd45a044c5a20f0ebf5db47c6eb7906584e927ca48f3c14ecd6"
  license "MIT"
  head "https://github.com/plutov/oq.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"oq")
  end

  test do
    (testpath/"openapi.yaml").write "not: [valid\n"
    output = shell_output("#{bin}/oq #{testpath}/openapi.yaml 2>&1", 1)
    assert_match "unable to parse specification", output
  end
end
