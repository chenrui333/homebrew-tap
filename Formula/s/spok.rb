class Spok < Formula
  desc "Lightweight build system and command runner"
  homepage "https://followtheprocess.github.io/spok/"
  url "https://github.com/FollowTheProcess/spok/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "e39df3d92c1a6f892c06f09195fa84a505f6a6e394cf06ec33d77ce26e306881"
  license "Apache-2.0"
  head "https://github.com/FollowTheProcess/spok.git", branch: "main"

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
