class Unisondb < Formula
  desc "Log-Native, Real-Time Database for AI and Edge Computing"
  homepage "https://unisondb.io/"
  url "https://github.com/ankur-anand/unisondb/archive/b082ab28a62dd044fd5294d7b7394de1cb75f7fe.tar.gz"
  version "0.0.1"
  sha256 "262dfac95950bff717caf600179db91c58f3a34292cb6014a3e1a3ba14c7456c"
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
