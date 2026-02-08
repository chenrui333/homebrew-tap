class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.3.3.tar.gz"
  sha256 "26b5b8e6402ba8313ae5175347aac9bf58dd4e0d9eee9561b5c24385ea6203f5"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26f21f4b03d7f3f1fdaa225dd9a15de316fd3cec00708910be485d654b10d5e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0c0e52ae46adbc0c52f77e632f198e6c41ea17e028b100ea454bcd8e871872a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27c0f2bb6032d49561d5de934f7c08257ed6c7ba78f29451273d8f7f06902828"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54522382b0de7034ac1791723852dd60acf6ab619fedeee62150106fea7b0406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e070237d98ea9c3a65ffec586e414b5f37ec09854b59809d81294decc7c8efa"
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
