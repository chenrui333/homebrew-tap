class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.24.1.tar.gz"
  sha256 "b929e03dcff4654858cddb7178964a2e493fb9922de337b0cfc0b1f4587e8d48"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee14ae1db61f828055c9e61667c3bd9d333fc6e4e5099e8a79054863b62f6119"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17d2589eb296b1944fa19a97695fe3d864a1bba6af12e986a23f86c9edcb5545"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cb881dbb0bd4f05a2d5e964fc35f095cbabdb546e6f7ede151e86022b3ff8ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5bf0889e4afb637921942a39a1f01d9aad096b9cfdf5f1a0b5da928cdc64501"
    sha256 cellar: :any,                 x86_64_linux:  "a0830888e5a9560d844e9ee212097cbb112aa2d8781d8fc759783e24431442c3"
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
