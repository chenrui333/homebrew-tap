class Diskbloom < Formula
  desc "Visualize disk usage as a terminal treemap"
  homepage "https://github.com/Zingzy/diskbloom"
  url "https://github.com/Zingzy/diskbloom/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "b0fa7c67c17251423b7e89fecf4c4d1f3722537a0049ba2771d90e24d0c8ebad"
  license "Apache-2.0"
  head "https://github.com/Zingzy/diskbloom.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f09d8ea52f05bbbc0173c1705a6ffb6a4ec8507a4a43546059d9e099e164b192"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f09d8ea52f05bbbc0173c1705a6ffb6a4ec8507a4a43546059d9e099e164b192"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f09d8ea52f05bbbc0173c1705a6ffb6a4ec8507a4a43546059d9e099e164b192"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d081d18e1feb594cd698ab32f947b3bd459308b07485664171ab11fc49195b3a"
    sha256 cellar: :any,                 x86_64_linux:  "b00db003b61442277497b4ba9c380b057533490241a555ca058f832267c2ffe2"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/diskbloom --version")
    # TODO: Replace the terminal requirement check when upstream exposes a headless scan mode.
    # Bubble Tea opens /dev/tty when stdin is redirected; detach the child from its terminal.
    (testpath/"no-tty.rb").write <<~RUBY
      pid = fork do
        Process.setsid
        $stdin.reopen(File::NULL)
        exec ARGV.fetch(0), ARGV.fetch(1)
      end
      Process.wait(pid)
      exit $?.exitstatus
    RUBY
    output = shell_output("#{RbConfig.ruby} no-tty.rb #{bin}/diskbloom #{testpath} 2>&1", 1)
    assert_match "error opening TTY", output
  end
end
