class Clipse < Formula
  desc "Configurable TUI clipboard manager for Unix"
  homepage "https://github.com/savedra1/clipse"
  url "https://github.com/savedra1/clipse/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "ec906744103a611cc1045a9d65f20b13b454ee046fd979abf1341a1b78fe553e"
  license "MIT"
  head "https://github.com/savedra1/clipse.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdc55801c7b5f6e7759900416b42be37f4f2df792b638ad0be145518f8df26de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74e802aa9ff7f24513f48bd6c79be2e686b98bdbc302c333b852b0295471f6c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baf6c5f8fec50fb1ee493cbbb4e4d8fb3a0676e755a7f839990e57195db1c043"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "380b89d0604d210e40efaaa03ba4bd2ad021d55a0e637c180d81b39278f1d4f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9ce6751521fc4b4e6ae8ce04f7d6c7d5b1b8351fa58737c3b7c19f985489620"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "libx11"
    depends_on "libxfixes"
    depends_on "libxtst"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clipse -v")

    test_string = "Homebrew clipse test"
    with_env(XDG_CONFIG_HOME: testpath/".config") do
      system bin/"clipse", "-a", test_string
      assert_equal test_string, shell_output("#{bin}/clipse -output-all unescaped").chomp
    end
  end
end
