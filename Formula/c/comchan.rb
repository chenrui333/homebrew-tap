class Comchan < Formula
  desc "Minimal serial monitor and plotter for embedded applications"
  homepage "https://github.com/Vaishnav-Sabari-Girish/ComChan"
  url "https://github.com/Vaishnav-Sabari-Girish/ComChan/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "ecfbdc73a70ac0d873e84fd7b1443bcb4036a8b15c094aff01ca62fd97745ee3"
  license "MIT"
  head "https://github.com/Vaishnav-Sabari-Girish/ComChan.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62e578cc9a42c13abbca28692f97f29d253f14c66ede255fa8807381c7825397"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "424999fbc39012b3e64bf8127912c72a5f48ff58fe7bdf39ecee6db4a5cfc147"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d30d66e6e523d6d08b6f9905f0c880ddaafa792f17f1cd64d039cd10781b5d06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c1b711029186ff92537cbc05b0bd162972dbbb88d85b0edfe56f8ae34ce3ffd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ea9579b4298181619c87128b30124cb1790335d6c8203701d38e6bc5ce56bfd"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "systemd" # for libudev
  end

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/comchan --version")

    shell_output("HOME=#{testpath} #{bin}/comchan --generate-config")

    config = if OS.mac?
      testpath/"Library/Application Support/comchan/comchan.toml"
    else
      testpath/".config/comchan/comchan.toml"
    end
    assert_path_exists config
    assert_match 'port = "auto"', config.read
  end
end
