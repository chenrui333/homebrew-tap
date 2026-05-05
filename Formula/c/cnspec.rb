class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.8.0.tar.gz"
  sha256 "d570a816c13541c0b23b6e7e03baf990641a87d876e77cd6d27f0143f00bd091"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4423f53863d96c83864cc36f5e2999fdf70f3ca802658b91213500dcb991f95e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7a1bacab77e22c4211896e908f11d44f00f7bb90d005c01741d3a7f33802ddc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92148e9ae95b1ca45a470466b51296aa3479afb9332f2a44a5ea70bde11be3f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e56372fa863c4ef45cd10229ecf732056dffe9e367d5d73790cddee207e872c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bded34b6b3829a9c77d28d2c1cc5ab2e1265136b512213189ba093a38b342d5"
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
