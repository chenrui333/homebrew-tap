class Sish < Formula
  desc "HTTP(S)/WS(S)/TCP Tunnels to localhost using only SSH"
  homepage "https://docs.ssi.sh/"
  url "https://github.com/antoniomika/sish/archive/refs/tags/v2.23.0.tar.gz"
  sha256 "fbf741b12f3037dd1307656d1f6ff3be53643882df936c89bcf98f938c9cd29a"
  license "MIT"
  head "https://github.com/antoniomika/sish.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2215dda94f913bc4eb3df804a31f30ad8e70bd7f8548913c70ce1f94219a3759"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2215dda94f913bc4eb3df804a31f30ad8e70bd7f8548913c70ce1f94219a3759"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2215dda94f913bc4eb3df804a31f30ad8e70bd7f8548913c70ce1f94219a3759"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7facec36be91a66eb471240d2c2680539f6032660b36e20da6c2187c8c0ce90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc2962ea14837ea116cc3f3b6c9f7b88df96273353182632632434f8f80da22b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/antoniomika/sish/cmd.Version=#{version}
      -X github.com/antoniomika/sish/cmd.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sish --version")
  end
end
