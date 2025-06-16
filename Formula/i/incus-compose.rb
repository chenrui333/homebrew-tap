class IncusCompose < Formula
  desc "Missing equivalent for `docker-compose` in the Incus ecosystem"
  homepage "https://github.com/bketelsen/incus-compose"
  url "https://github.com/bketelsen/incus-compose/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "b7505fb5d92a0b30ed3bf014208ccad8d754f48f1eb4f2b6627201bdefdc4056"
  license "MIT"
  head "https://github.com/bketelsen/incus-compose.git", branch: "main"

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

    generate_completions_from_executable(bin/"incus-compose", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/incus-compose --version")

    assert_match "no compose.yaml file found", shell_output("#{bin}/incus-compose up 2>&1", 1)
  end
end
