class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.8.3.tar.gz"
  sha256 "9f5259685eef89ca9931799360f06f89862bcd53caba6d2fca99a7db7e33ff57"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac2a8c03847b66fd760367ac0465545105e22a60f83cec2acd242bb95931c912"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f9ee4f9b948dfffbefe5b8016f72206a2773d4758b27634dab55364047c97cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e48808e6ec22ac8c315e2f86511d24f089783dd74db1fe3220798ac58b6a691d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79864d1140a6ef94a89ee9ffdab5b07ebe24aa5d04d45173cc7176d0ce7be443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dec9b069e95259a0b304e670f6ecae7ae8faea9b7a97921ff7b3b306ca6560cc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.mondoo.com/cnquery/v#{version.major}.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./apps/cnspec"

    generate_completions_from_executable(bin/"cnspec", shell_parameter_format: :cobra)
  end

  test do
    system bin/"cnspec", "version"

    output = shell_output("#{bin}/cnspec policy list 2>&1", 1)
    assert_match "Error: cnspec has no credentials. Log in with `cnspec login`", output
  end
end
