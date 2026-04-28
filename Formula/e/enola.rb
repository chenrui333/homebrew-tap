# framework: cobra
class Enola < Formula
  desc "Hunt down social media accounts by username across social networks"
  homepage "https://github.com/TheYahya/enola"
  url "https://github.com/TheYahya/enola/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "3d1e08662a2a535773379b24d40c542fac406318c8ea6db6d6c191dfd0f2f703"
  license "MIT"
  head "https://github.com/TheYahya/enola.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23382c32502d3d9ee50f94fdffd0122a2317b284d56a3b126b488460a725921a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf73baccb70013d30365abeba638735d47f7bd53f4cf8f6fffb6bf75169b4f42"
    sha256 cellar: :any_skip_relocation, ventura:       "9042ae5adb7990a0cdacb335b96502a3f975f5e2f40c3759c3f5fd626d60745f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "051c8cba44f3a7866970fc9bbb2045ecd5490226b0588cc8be216b111a1d979b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/enola"
  end

  test do
    # Fails in Linux CI with `/dev/tty: no such device or address`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    Open3.popen3("#{bin}/enola --site GitHub brewtest") do |stdin, stdout, _, w|
      stdin.close
      sleep 1
      Process.kill("TERM", w.pid)
      output = stdout.read
      assert_match "No items", output
    end
  end
end
