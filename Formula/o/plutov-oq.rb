class PlutovOq < Formula
  desc "Terminal OpenAPI Spec viewer"
  homepage "https://github.com/plutov/oq"
  url "https://github.com/plutov/oq/archive/refs/tags/v0.0.22.tar.gz"
  sha256 "4b4b3f294482bdd45a044c5a20f0ebf5db47c6eb7906584e927ca48f3c14ecd6"
  license "MIT"
  head "https://github.com/plutov/oq.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "675fb776654f57413074f2b422bf973e58f5bc407962c13cb70cefe1235def69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "675fb776654f57413074f2b422bf973e58f5bc407962c13cb70cefe1235def69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "675fb776654f57413074f2b422bf973e58f5bc407962c13cb70cefe1235def69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a2ad51f54f8c1b9778d6b6b3751138e36d5ea0b396b9c3f864f6c2bc748e6d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "446e957d0967425e9005a922653dcc09d3bdb994a7ab771167b86a4ccf750b55"
  end

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
