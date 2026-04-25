class Satview < Formula
  desc "Terminal-based real-time satellite tracking and orbit prediction application"
  homepage "https://github.com/ShenMian/tracker"
  url "https://github.com/ShenMian/tracker/archive/refs/tags/v0.1.20.tar.gz"
  sha256 "9a5ff9f12230b6821805a07a76e61420d52f0ed60ee4a5da2cc37917abdebebf"
  license "Apache-2.0"
  head "https://github.com/ShenMian/tracker.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc3d510c1a82733d45a2ec50345f8efd73091a29b6c5789a1203115636545f96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91059b8f3e8cb412a7e4dcc43f32abd6a6123de5f6157c2b7a43544eb51938ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa08d595d3af588b1e1c8cf3a3f7f5bfd8c6fb7cddbead4206287745a6756862"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1febc5eff86adff402e6a1919e1eeaa96607ec4ba793d158abf7a2bab3d4af04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbca8d14f1b68528591849185995e3af65e97566441e551191d8f1fe470d638b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args # artifact would still be `tracker`
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tracker --version")

    output_log = testpath/"tracker.log"
    pid = if OS.mac?
      spawn "script", "-q", File::NULL, bin/"tracker", [:out, :err] => output_log.to_s
    else
      spawn "script", "-q", "-c", bin/"tracker", File::NULL, [:out, :err] => output_log.to_s
    end
    sleep 2
    Process.kill("TERM", pid)
    Process.wait(pid)
    output = output_log.read
    assert_match "\e[?1049h", output
    refute_match "No such device or address", output
  rescue Errno::ESRCH
    output = output_log.exist? ? output_log.read : ""
    assert_match "\e[?1049h", output
    refute_match "No such device or address", output
  end
end
