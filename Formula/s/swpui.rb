class Swpui < Formula
  desc "Interactive search and replacement preview"
  homepage "https://github.com/beeb/swpui"
  url "https://github.com/beeb/swpui/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "517a8f19498d3e5d689baabb7e48001aba81042c727010491fec27c092cd236d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/beeb/swpui.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "def27619ad739c6ec0e76522d9ada50679d416df60fc3c50ec4fa0406b20ebc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7110318b98393c49a91493f4502d6074272e4238a8b34ea625af65d4e1ca0269"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a924ea7fcc301e3b48869c4ddebac9c80970ed305f09d373ded085f9c4feaf0f"
    sha256 cellar: :any,                 arm64_linux:   "36b1a54d320f9411b286ce76560ea84bd0a319c797952dbbdeaaba0fe31c596b"
    sha256 cellar: :any,                 x86_64_linux:  "fb697d3a314c77b81fe3c9e0566c8974d8cae651df571cec18ef0a0a0f0b2008"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # TODO: Upstream does not expose a version command.
    # FIXME: Replace the startup error check when upstream adds a headless preview mode.
    (testpath/"swpui.log").mkpath
    output = shell_output("DEBUG=1 #{bin}/swp 2>&1", 1)
    assert_match "Is a directory", output
    assert_predicate testpath/"swpui.log", :directory?
  end
end
