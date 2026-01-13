class Hauler < Formula
  desc "Airgap Swiss Army Knife"
  homepage "https://docs.hauler.dev/docs/intro"
  url "https://github.com/hauler-dev/hauler/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "958dfc96475ed9a437e98e560291a315ee997bfff14806b7da454c4dda5ec039"
  license "Apache-2.0"
  head "https://github.com/hauler-dev/hauler.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86c79dbcd14defd4f4fa6779785d1995852317db4029a9cfef2fd9a3ace0d1b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e67f7bb347af566174ac9cc5cfb3940fb0748a9fdfc79f7bb0ce123670722469"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e6ef81b24e0a7a512de2e7cd5bcb6bfe6754ddc4a4d583175eebbfbea998582"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c794ec3b43634bad29f6b9c002deda6948986fc77cdf061d9fed9ad59708ec0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0825f0f0655a8c39516f653bcb9fb2889761f576f6858e2f2154c47ee6206b8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X hauler.dev/go/hauler/internal/version.gitVersion=#{version}
      -X hauler.dev/go/hauler/internal/version.gitCommit=#{tap.user}
      -X hauler.dev/go/hauler/internal/version.gitTreeState=clean
      -X hauler.dev/go/hauler/internal/version.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/hauler"

    generate_completions_from_executable(bin/"hauler", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hauler version")

    assert_match "REFERENCE", shell_output("#{bin}/hauler store info")
  end
end
