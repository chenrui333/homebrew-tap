class IncusCompose < Formula
  desc "Missing equivalent for `docker-compose` in the Incus ecosystem"
  homepage "https://github.com/bketelsen/incus-compose"
  url "https://github.com/bketelsen/incus-compose/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "b7505fb5d92a0b30ed3bf014208ccad8d754f48f1eb4f2b6627201bdefdc4056"
  license "MIT"
  head "https://github.com/bketelsen/incus-compose.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11d28f4f9ecc094bab8d78264653a38e53fe3c71fcb18299fab087c8f1b86bb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6abdf40e5df4578160293d60d3f72826a3e0f64bfa08deb2851ca01df4149d59"
    sha256 cellar: :any_skip_relocation, ventura:       "0eae376f76a49f579bde41d2f0787b6dead7c2825651480dacfad3856476fa50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d88f7f507d2a6c89038f9c222b25e27688c1246343adf7ef325706707711ce71"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/bketelsen/incus-compose/cmd.date=#{time.iso8601}
      -X github.com/bketelsen/incus-compose/cmd.treeState=clean
      -X github.com/bketelsen/incus-compose/cmd.version=#{version}
      -X github.com/bketelsen/incus-compose/cmd.commit=#{tap.user}
      -X github.com/bketelsen/incus-compose/cmd.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"incus-compose", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/incus-compose --version")

    assert_match "no compose.yaml file found", shell_output("#{bin}/incus-compose up 2>&1", 1)
  end
end
