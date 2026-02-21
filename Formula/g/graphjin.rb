class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "e51c898951f8350ba45f0f9506ea4d9068c1228fbb953c29bc2cec8aa100a008"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1b3ca4f172eac5936be442a74eeb7d367ec8f5462193bd9a836ab58db7437a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4073bc35feb32cfabafeded061dc811046e750f3ea582943cec925dc1851c60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b35424b3a54fe88afbc2a4568bcbf6acb505a0c877a1f843701025f1c630172"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c676ca453c71b58a4d0190a19194386ec34e94c14af6626231980f33b75ca778"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55a2c2f2d1e8318ecde636e8fe16f71e71736dae317c235475fda63284e2269c"
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

    system bin/"graphjin", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end
