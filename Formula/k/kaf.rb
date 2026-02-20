class Kaf < Formula
  desc "Modern CLI for Apache Kafka"
  homepage "https://github.com/birdayz/kaf"
  url "https://github.com/birdayz/kaf/archive/refs/tags/v0.2.13.tar.gz"
  sha256 "df0ad80c7be9ba53a074cb84033bd477780c151d7cbf57b6d2c2d9b8c62b7847"
  license "Apache-2.0"
  head "https://github.com/birdayz/kaf.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "12b0f51e64ce92e90765846a82af44511676e9c60fa92031b0cc4b4f7635052c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12b0f51e64ce92e90765846a82af44511676e9c60fa92031b0cc4b4f7635052c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12b0f51e64ce92e90765846a82af44511676e9c60fa92031b0cc4b4f7635052c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b8047dc8f4c415901514d77ec0a457734b6064fd56ce286c41df6488770bc62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c5edb4ca249160285dc9d8dbad2510d19c0fb4f42734565c2654fb9d24b9178"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=Homebrew"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kaf"

    generate_completions_from_executable(bin/"kaf", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kaf --version")

    ENV["HOME"] = testpath
    system bin/"kaf", "config", "add-cluster", "local", "-b", "localhost:9092"
    system bin/"kaf", "config", "use-cluster", "local"
    assert_equal "local\n", shell_output("#{bin}/kaf config current-context")
  end
end
