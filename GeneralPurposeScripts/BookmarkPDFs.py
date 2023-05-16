from io import BytesIO
import os
import re
import sys
import getopt
import subprocess

# implement pip as a subprocess:
subprocess.check_call([sys.executable, '-m', 'pip', 'install', '-r', fr'G:\!Actuarial\TriFile\_Python\bookmarks\AutoBookmark_PackageRequirements.txt'])

path = ""
exhibits = None
appendices = None

from PyPDF2 import PdfReader, PdfWriter


class AutoBookmark:
    """Automatically create bookmarks for final reports."""

    proper_name_dict = {
        "-fs-": "/",
        "-bs-": "\\",
        "-co-": ":",
        "-as-": "*",
        "-q-": "?",
        "-lt-": "<",
        "-gt-": ">",
        "-bar-": "|",
    }

    def __init__(self, root_folder):
        """Initialize AutoBookmark instance."""
        self.root_folder = root_folder
        os.chdir(root_folder)

        self.report = PdfWriter()

    def printBookmarkStructure(self, report_type):
        """Display the bookmark hierarchy."""
        startpath = os.path.join(self.root_folder, report_type)

        for root, dirs, files in os.walk(startpath):

            level = root.replace(startpath, "").count(os.sep)

            indent = " " * 4 * (level)

            "Remove Seg#_ prefix."

            match_seg = re.search(
                "Seg[0-9]_", "{}{}".format(indent, os.path.basename(root))
            )

            match_term = re.search(
                "Term[0-99]_", "{}{}".format(indent, os.path.basename(root))
            )

            if "ignore" not in root:
                if match_seg:
                    print(
                        "{}{}".format(
                            indent, os.path.basename(root).lstrip(match_seg.group(0))
                        )
                    )
                elif match_term:
                    print("{}{}".format(indent, os.path.basename(root)[7:]))
                else:
                    print("{}{}".format(indent, os.path.basename(root)))

                subindent = " " * 4 * (level + 1)

                "Loop through file and remove file extension."
                for f in files:
                    print("{}{}".format(subindent, f))

    def createReport(self, report_type):
        """Make final report."""

        start_path = os.path.join(self.root_folder, report_type)
        bookmark_destination = []
        parent_list = []

        # Walk through the directory and combine the PDFs into a single
        # document.
        for root, dirs, files in os.walk(start_path):
            # Directories marked ignore will not be included in the merged
            # document.
            if "ignore" not in root:
                bookmark_destination.append(len(self.report.pages))

                # Append PDF files into the merged document.
                pdfs = [doc for doc in files if doc.endswith(".pdf")]
                for pdf in pdfs:
                    self._append_pdf(os.path.join(root, pdf))

        i = 0

        for root, dirs, files in os.walk(start_path):
            if "ignore" not in root:

                level = root.replace(start_path, "").count(os.sep)
                bookmark_name = self._name_bookmark(root)

                if level == 0:
                    parent = self.report.add_outline_item(
                        bookmark_name, bookmark_destination[i], None
                    )
                    parent_list.append(parent)
                else:
                    parent = self.report.add_outline_item(
                        bookmark_name, bookmark_destination[i], parent_list[level - 1]
                    )
                    if level >= len(parent_list):
                        parent_list.append(parent)
                    else:
                        parent_list[level] = parent

                i += 1

        # Write final report to PDF.
        output = open(os.path.join(self.root_folder, report_type + ".pdf"), "wb")
        self.report.write(output)

    def cleanDirectory(self):
        """Removes empty folders in the Appendices and Exhibits folders"""

        for root, dirs, files in os.walk(self.root_folder, topdown=False):
            if not os.listdir(root):
                os.rmdir(root)

    def transformName(self, name):
        for key, value in self.proper_name_dict.items():
            if key in name:
                name = name.replace(key, value)

        return name

    def _append_pdf(self, pdf):
        with open(pdf, "rb") as fileobj:
            fileobj.seek(0)
            filecontent = fileobj.read()
            fileobj = BytesIO(filecontent)
            reader = PdfReader(fileobj, strict=False)
            self.report.append_pages_from_reader(reader)

    def _name_bookmark(self, root):
        """Remove Seg#/Term# prefix used to force ordering."""
        match_seg = re.search("Seg[0-9]_", "{}".format(os.path.basename(root)))
        match_term = re.search("Term", "{}".format(os.path.basename(root)))

        if match_seg:
            bookmark_name = self.transformName(os.path.basename(root)[5:])
        elif match_term:
            bookmark_name = self.transformName(os.path.basename(root)[7:])
        else:
            bookmark_name = self.transformName(os.path.basename(root))

        return bookmark_name


def main(argv):
    path = ""
    exhibits = None
    appendices = None

    try:
        opts, args = getopt.getopt(argv, "hp:e:a:", ["path=", "ex=", "ap="])
    except getopt.GetoptError:
        print("AutoBookmark.py -p <path> -e <ex> -a <ap>")
        sys.exit(2)

    for opt, arg in opts:
        if opt == "-h":
            print("AutoBookmark.py -p <path> -e <ex> -a <ap>")
            sys.exit()
        elif opt in ("-p", "--path"):
            path = arg
        elif opt in ("-e", "--ex"):
            exhibits = arg
        elif opt in ("-a", "--ap"):
            appendices = arg

    x = AutoBookmark(path)
    x.cleanDirectory()

    if exhibits:
        pdf_e = AutoBookmark(path)
        try:
            pdf_e.createReport("Exhibits")
        except:
            # pdf_e.report.write(open(pdf_e.root_folder + "\\" + "Exhibits.pdf",
            #                   'wb'))
            input("An error occured. Press any key to exit")

    if appendices:
        pdf_a = AutoBookmark(path)
        try:
            pdf_a.createReport("Appendices")
        except Exception as e:
            # pdf_a.report.write(open(pdf_a.root_folder + "\\" + "Appendices.pdf",
            #       'wb'))
            print(e.__str__())
            input("An error occured. Press any key to exit")


if __name__ == "__main__":
    try:
        main(sys.argv[1:])
    except Exception as e:
        print(e.__str__())
        input("Press enter to exit the program.")
