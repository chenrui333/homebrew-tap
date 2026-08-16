class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.21.tar.gz"
  sha256 "2a3710fc712ffcf58ab398aef1b26bb529a9173af25e8c3951cddf4ce3c074c2"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fd7f2ad1107c301698350d8463232b11bc85dd3210a40e5c4ca621efef99852f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e04be49ff20579d9c6e62ae2c3e7552d315f907cfe4325815061a8aae54a0802"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "539fe80da8084724c8d664b150bcd46fa24c792f44c92969063123bd6e657cb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "62ddc887ef12d56e8fc4d5fb82f43bc90ca4681f10008f15be07a25cc9ca8885"
    sha256 cellar: :any,                 x86_64_linux:  "8d60ba9906f08adb1adac4347c8787f957b2a41ca2bc77daea2f9ac8acf04d0e"
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
