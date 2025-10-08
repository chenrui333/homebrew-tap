class Av < Formula
  desc "Manage stacked PRs with Aviator"
  homepage "https://www.aviator.co/"
  url "https://github.com/aviator-co/av/archive/refs/tags/v0.1.12.tar.gz"
  sha256 "4d7ff2ae4b51421286c93f97a3f633734ffdf0882462374fac8ee08e20d14f1f"
  license "MIT"
  head "https://github.com/aviator-co/av.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0296f45eae83f53b4705c97c0e10d43a9a933a37ac4b18b1052e4a016b798081"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0296f45eae83f53b4705c97c0e10d43a9a933a37ac4b18b1052e4a016b798081"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0296f45eae83f53b4705c97c0e10d43a9a933a37ac4b18b1052e4a016b798081"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "108204e3d45819966c59a83ca9572aee3bf393fbda146f390214dc9b99c3a1de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f1cdb27e678590f20b520421f37374661e8ecdc6e1333ec320b978da36f81b4"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

    ldflags = "-s -w -X github.com/aviator-co/av/internal/config.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/av"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/av version")

    ENV["GITHUB_TOKEN"] = "testtoken"

    system "git", "init"

    output = shell_output("#{bin}/av init 2>&1", 1)
    assert_match "error: this repository doesn't have a remote origin", output
    assert_path_exists testpath/".git/av"
  end
end
