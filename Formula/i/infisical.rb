class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://github.com/Infisical/infisical/archive/refs/tags/infisical-cli/v0.34.2.tar.gz"
  sha256 "cc0ae13298d6766f061cf968d77a4c2d392517aa460f1d8798ec25fe27e99dd9"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{^infisical-cli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f982449d2714acef10d8867a05e78e99183464db137e148e3a6b5a40840ff251"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f0ba4cb92911ca965d48e091a7bbd528e447e365648e816c4c12d573b297d98"
    sha256 cellar: :any_skip_relocation, ventura:       "49b84ce94681526dbd221b7a8f6df0240351fbe444df9e532966f543f7c80a0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37adb9137ed44a27725da9bd1507df5d43b864a6a6db6b61e889db79cde4f71d"
  end

  depends_on "go"

  def install
    cd "cli" do
      ldflags = %W[
        -s -w
        -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
      ]
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical init 2>&1", 1)
    assert_match "You must be logged in to run this command.", output
  end
end
