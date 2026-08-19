class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.28.tar.gz"
  sha256 "cfd17be5861697257680511aaf7aaf45fc5a957829dac46f3bce2f1521c88e7f"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52129c911fe4636cd76713b2d6f2dafbe25243fe137ec235f9db76e3267c1f39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf932469d2084bf56d7c6657e41dd153184b93a5c3cc49a384c95b5947eb3b8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de54ea3da1e74ff2cd7a3a11007a663b0a4f7f421d086f6227761de9fe539c1a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6996694f0a5f2fa0becb82889071fa40a1c77397ffda18c8161d80d1383e26f"
    sha256 cellar: :any,                 x86_64_linux:  "ef334eeed014e2c8f30550fb2627244538784a1184df3efbb26c843a65ce72b9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X github.com/dosco/graphjin/serv/v3.version=#{version}
    ]

    cd "cmd" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"graphjin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graphjin version")

    system bin/"graphjin", "serve", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
