class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.26.tar.gz"
  sha256 "f8a7c01eba6bc06490613c1cc56962b48471675209a68792749f8d90c377e76d"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9cb6d1b1aedf17ae25cf31e5a1d5316215a224caafd9c2261252e431493abbb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7accfc411f22e065aaadaf620641899efb98beb462fd826a8f07b5102ae06e60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c032538730eeeee666211f0a3e627327175fea538d1fb04d6cd27e1febf7dd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "33ed71fb2dd41f3cc8a190990fe23a9c6a2a11e0ea4b675cafc0561480a4b51f"
    sha256 cellar: :any,                 x86_64_linux:  "acef869192f2781ae80593c0b2857758e589bf0a8c166b7372ea9d4ceb9d440c"
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
