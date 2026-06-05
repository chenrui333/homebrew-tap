class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.21.1.tar.gz"
  sha256 "42d93db55613717e9d41cd52e12abeaee19d94b3f48daaa2d72b5cad4dcb5ee0"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b81509687a18dd7648a2aa2863aef89fd6fb1f2f42a02e5c2a3a0039cce2be6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8db4d7ad6db8c581adda5f342bd82aec3266f4d44d9485ed269b634e93447ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ffb0184fbd26e101ff61f4f5bb96ed9fe7851a6cb46dc80955fe0e038126bf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d473212d0e9dff691437274f058adf0189ec7df2753c3b1065cb91e36d0cc6aa"
    sha256 cellar: :any,                 x86_64_linux:  "092a07afa256532184c30dc015eb939ed9f2b0ab47d7ab51b220c2472d0aa674"
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
