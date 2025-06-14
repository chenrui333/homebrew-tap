class Spok < Formula
  desc "Lightweight build system and command runner"
  homepage "https://followtheprocess.github.io/spok/"
  url "https://github.com/FollowTheProcess/spok/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "e39df3d92c1a6f892c06f09195fa84a505f6a6e394cf06ec33d77ce26e306881"
  license "Apache-2.0"
  head "https://github.com/FollowTheProcess/spok.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e33888c40f84e96fa4f61d7aad5c786ad4e89880b4c6d2307378fed9c6e76d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b5f12451b580d522ba405b6f65d3b728d3fe97339e069fce73c51374b3ecff64"
    sha256 cellar: :any_skip_relocation, ventura:       "5d5af81b036a99ae83a0969f91501cd984f9adf9e44f2a38bdae52fe0bb71c02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a6a2f1fd38e37e627f265e1adcddc1a95e53c3e8532d65db92253e04915f9fb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/FollowTheProcess/spok/cli/cmd.version=#{version}
      -X github.com/FollowTheProcess/spok/cli/cmd.commit=#{tap.user}
      -X github.com/FollowTheProcess/spok/cli/cmd.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/spok"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spok --version 2>&1")

    system bin/"spok", "--init"
    assert_path_exists "spokfile"
    rm "spokfile"

    test_spokfile = testpath/"spokfile"
    test_spokfile.write <<~EOS
      task default() {
        echo "Hello, Spok!"
      }
    EOS

    assert_match "Hello, Spok!", shell_output("#{bin}/spok --spokfile #{test_spokfile}")
  end
end
