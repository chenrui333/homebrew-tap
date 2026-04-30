class Lazyjira < Formula
  desc "Fast, keyboard-driven terminal UI for Jira"
  homepage "https://github.com/textfuel/lazyjira"
  url "https://github.com/textfuel/lazyjira/archive/refs/tags/v2.11.1.tar.gz"
  sha256 "a6767703a555b406e05e531ca3a1f1d2bb58b6ddd7e1cf4ec44bee5c6f913d3c"
  license "MIT"
  head "https://github.com/textfuel/lazyjira.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ec079b962fc1fa623a0f6279f1ca546824cab53ee73be6eccaea7253087bc03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ec079b962fc1fa623a0f6279f1ca546824cab53ee73be6eccaea7253087bc03"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ec079b962fc1fa623a0f6279f1ca546824cab53ee73be6eccaea7253087bc03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "191a449546d8b3dcc84edf9d71055b9b2fd8c039e47c631034ab761b183c80c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "285e5ae5362d4142ae1c2388ac1807733fb5954c7dfd8f590a1eb7cd8f7c0b9f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    ENV["GOFLAGS"] = "-buildvcs=false"
    system "go", "build", *std_go_args(ldflags:), "./cmd/lazyjira"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyjira --version")
  end
end
