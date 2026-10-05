class IncusCompose < Formula
  desc "Missing equivalent for `docker-compose` in the Incus ecosystem"
  homepage "https://github.com/bketelsen/incus-compose"
  url "https://github.com/bketelsen/incus-compose/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "b7505fb5d92a0b30ed3bf014208ccad8d754f48f1eb4f2b6627201bdefdc4056"
  license "MIT"
  head "https://github.com/bketelsen/incus-compose.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4cd333aec8a4d9f13a53d820ee660beb337469568515a8791a38cedd40f03310"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4cd333aec8a4d9f13a53d820ee660beb337469568515a8791a38cedd40f03310"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6dabb45abb25674cb1aa7366fe4f9c639698c01183490aa02b6526e4f9ad5601"
    sha256 cellar: :any,                 x86_64_linux:  "6ef1aea0713b66b06b6550aa06161cd38e25ec59ed9cb241b4421f3c4755796f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
