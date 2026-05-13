class Unisondb < Formula
  desc "Log-Native, Real-Time Database for AI and Edge Computing"
  homepage "https://unisondb.io/"
  url "https://github.com/ankur-anand/unisondb/archive/4d17a6016c7c04546e29b87ca71cd71a94400bd0.tar.gz"
  version "0.0.1"
  sha256 "a67fff1b1a17db3b3df128d4ae22fe6e3ba33223a8432e95a0aca0adc9fe07e9"
  license "Apache-2.0"
  head "https://github.com/ankur-anand/unisondb.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/unisondb"
  end

  test do
    assert_match "Database + Message Bus. Built for Edge", shell_output("#{bin}/unisondb help")
  end
end
