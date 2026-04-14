class Lazyjira < Formula
  desc "Fast, keyboard-driven terminal UI for Jira"
  homepage "https://github.com/textfuel/lazyjira"
  url "https://github.com/textfuel/lazyjira/archive/refs/tags/v2.9.0.tar.gz"
  sha256 "afef1d999b21008366d0ac2618ae6c4f73f1bc111737cb9e74d649805ed575b3"
  license "MIT"
  head "https://github.com/textfuel/lazyjira.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e967c7dba2a778aff76ab86d983ab7509ade0db2c70dbf46bf04256e9f913446"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e967c7dba2a778aff76ab86d983ab7509ade0db2c70dbf46bf04256e9f913446"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e967c7dba2a778aff76ab86d983ab7509ade0db2c70dbf46bf04256e9f913446"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da1c3011dc3076b47ab78619ea2ae7715115ab7f58eecb89ef631f66125ab593"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fc401e523e21e4e63ba862110e02919b163731f46b6bc15b0d32bb6c7386ce7"
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
