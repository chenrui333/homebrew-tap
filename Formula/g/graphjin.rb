class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.21.20.tar.gz"
  sha256 "4989a0ef83bbd6fee6fab2174b7967d78d4fa0ae6fcae2aac5de470594cc47e3"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a42c473edaaf35144752e3c1e439bad7b662f4d47069eb9585bad381be84709"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04d2ebb4c68a0a897109c13727d1af08895fd3cc487911338893ff939754f10f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12eeaec5a19d846773207fca2a8a1311c181a6b83e2a03f4240648f4b6a55441"
    sha256 cellar: :any,                 x86_64_linux:  "84166640c79c3b46edd0949a7e4254772629fd3a8521fef83df6686d237f3446"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    cd "cmd" do
      system "go", "mod", "download"
    end
  end

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
