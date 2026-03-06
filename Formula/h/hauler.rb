class Hauler < Formula
  desc "Airgap Swiss Army Knife"
  homepage "https://docs.hauler.dev/docs/intro"
  url "https://github.com/hauler-dev/hauler/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "7936b801001997a6f3ee7b9507bbe7f32b46397a66b3d2378e8a077d6de4890b"
  license "Apache-2.0"
  head "https://github.com/hauler-dev/hauler.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "15da569c8bd30748038ea2ea96120173f6ed1ec4d8040c44d9279f138271bd20"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "202671cc8f7e59010feb25c23267037f076fd490bbcd38bbd06d741ae858c4a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fec28ba6acaecd39e2c6001462e0b60d1e4a85557e5adf0912c24531b4bfdecd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4dc363dd7054d6a2878c19920027dd0dcf04f3fdb6ebcbbae4708c0469f7ce3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "769a7cb45fe72180b87426abc625e13645b5574fde575113665400cc1064a4cf"
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
