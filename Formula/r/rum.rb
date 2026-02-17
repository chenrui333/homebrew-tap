class Rum < Formula
  desc "TUI to list, search and run package.json scripts"
  homepage "https://github.com/thekarel/rum"
  url "https://github.com/thekarel/rum/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "4c780babaea3f7469bd19e0b117ce805cf477d516933cd96f029a280d6c763bb"
  license "MIT"
  head "https://github.com/thekarel/rum.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd7bdb72f9e36fdf9660cc1ab30caf7804470ebf99a4ef8cf2fa350069c077e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd7bdb72f9e36fdf9660cc1ab30caf7804470ebf99a4ef8cf2fa350069c077e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd7bdb72f9e36fdf9660cc1ab30caf7804470ebf99a4ef8cf2fa350069c077e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9e6ee93b041f21a863345fbd78b6d3ab3ddc5f4681f7270db98856fa81bb41e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8344fba4d0815fb0f15b27a949bd765498174375f805f3b35618fb6d445b399"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "test-package",
        "version": "1.0.0",
        "scripts": {
          "start": "echo Starting",
          "test": "echo Testing"
        }
      }
    JSON

    output = shell_output("#{bin}/rum -l #{testpath}/package.json")
    assert_match "start    echo Starting", output
  end
end
