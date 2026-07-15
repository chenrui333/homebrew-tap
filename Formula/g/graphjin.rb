class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.46.tar.gz"
  sha256 "fabe59085c865520d229d6f2eba8478c589de49e589e107ff2639325fd32af1a"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aab05334d3ada4a1623d7539d1af4aea4de8e4bf8664d1c9b8db2ff2f14b21d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a88aee01b9b1a5567247248323cdbf2b0ab256fa9a47ac8747dfbdcbe92d155d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80a5819f24261c9172d7ffaf9f99b95bba4a53be836921a64e23a6cd89d3a8d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43af44be5a5d1c3ad9be5a5b039d1606924e232f0e5f4ab5f6c00f7bf69ab0f8"
    sha256 cellar: :any,                 x86_64_linux:  "7939c9b606c4992c455f988aeb997f79f69a780e4cb89e6702853b645555bcee"
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
