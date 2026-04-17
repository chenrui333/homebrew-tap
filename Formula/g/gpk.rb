class Gpk < Formula
  desc "TUI dashboard that consolidates 36+ package managers into one interface"
  homepage "https://github.com/neur0map/glazepkg"
  url "https://github.com/neur0map/glazepkg/archive/refs/tags/v0.3.28.tar.gz"
  sha256 "1f90b1192b4d145d725f7132b0b72f9f9bb75d9931aebd49162d5111c00299c8"
  license "GPL-3.0-only"
  head "https://github.com/neur0map/glazepkg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3431610cf7ea3c39f94b5a55bf0df707f0c3109c5357f8c996b29d5a63a0b4ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3431610cf7ea3c39f94b5a55bf0df707f0c3109c5357f8c996b29d5a63a0b4ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3431610cf7ea3c39f94b5a55bf0df707f0c3109c5357f8c996b29d5a63a0b4ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7edff2eff622684b61dfb6c35293f314f329fed88043fe21109a30a2575bb48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1079bf595e6fe2f91abf0ad28f5304f05c9274ce98a0f547e6fcdda839da939"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    ENV["GOFLAGS"] = "-buildvcs=false"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gpk"
  end

  test do
    assert_match "gpk #{version}", shell_output("#{bin}/gpk --version")
  end
end
