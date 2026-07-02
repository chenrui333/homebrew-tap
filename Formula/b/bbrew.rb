class Bbrew < Formula
  desc "Bold Brew (bbrew) - A Homebrew TUI Manager"
  homepage "https://bold-brew.com/"
  url "https://github.com/Valkyrie00/bold-brew/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "ddf3d5e69da599fe6cb9660c50895b3572f31abb511d25e5d39547e9e7e95ae0"
  license "MIT"
  head "https://github.com/Valkyrie00/bold-brew.git", branch: "trunk"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c02c2ffddd6ba8405883a4006ded12b804716c89368e0c641c8515db2169077"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c02c2ffddd6ba8405883a4006ded12b804716c89368e0c641c8515db2169077"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c02c2ffddd6ba8405883a4006ded12b804716c89368e0c641c8515db2169077"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ecfbd427e1948536974e9d33ac0b79749f7775af81cc0be69e3f68a127e68c46"
    sha256 cellar: :any,                 x86_64_linux:  "9c986ed7786b708c31d4224bc672bb8346c719aaf592706fe911ee04c456baa4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X bbrew/internal/services.AppVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/bbrew"
  end

  test do
    (testpath/"Brewfile").write <<~EOS
      brew "wget"
    EOS

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"bbrew", "-f", testpath/"Brewfile", [:out, :err] => output_log.to_s
      sleep 8
      assert_match "Application error: terminal not cursor addressable", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
