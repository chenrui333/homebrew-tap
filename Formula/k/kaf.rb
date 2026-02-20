class Kaf < Formula
  desc "Modern CLI for Apache Kafka"
  homepage "https://github.com/birdayz/kaf"
  url "https://github.com/birdayz/kaf/archive/refs/tags/v0.2.13.tar.gz"
  sha256 "df0ad80c7be9ba53a074cb84033bd477780c151d7cbf57b6d2c2d9b8c62b7847"
  license "Apache-2.0"
  head "https://github.com/birdayz/kaf.git", branch: "master"

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
