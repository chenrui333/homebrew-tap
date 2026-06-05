class Cnspec < Formula
  desc "Open source, cloud-native security and policy project"
  homepage "https://github.com/mondoohq/cnspec"
  url "https://github.com/mondoohq/cnspec/archive/refs/tags/v13.21.1.tar.gz"
  sha256 "42d93db55613717e9d41cd52e12abeaee19d94b3f48daaa2d72b5cad4dcb5ee0"
  license "BUSL-1.1"
  head "https://github.com/mondoohq/cnspec.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "405d6262807188e78b198fd66df8fe7e26c111f82c4fc33ab9f900eb90a9f3e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac7cc6e990cef14dfa98b0f0160b8dd1c124ff8cf8849b6843636ec5757b0c42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b345575f234f3017b509da0bc8a3c165d47929e4e770e8ffbccaf1aa28512333"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "400bc3278249c0dafdb3b9d219ea99f945059d6a05237a7cbc01c4f2fa54498f"
    sha256 cellar: :any,                 x86_64_linux:  "74507c397a23e676d8681645bf49a22126c5b4831a1af066b028c131b9b8f915"
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
