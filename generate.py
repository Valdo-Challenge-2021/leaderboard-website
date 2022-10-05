"""Generate the template
"""
import re
import json
import argparse
from pathlib import Path
from typing import List, Mapping, Any

import pandas as pd


def main(options: argparse.Namespace):
    """
    :param options: Options containing input_csv, input_json, output_file and
    template_file
    """
    # Get json data
    with options.input_json.open("r") as fd:
        json_data: Mapping[str, Any] = json.load(fd)

    columns: List[str] = list(json_data["columns"].values())

    is_ascending: List[str] = {
        json_data["columns"][key]: value
        for key, value in json_data["is_ascending"].items()
        }

    # Get csv data
    csv_data: pd.Dataframe = pd.read_csv(options.input_csv)
    csv_data_list: List[List[str]] = []
    for _, csv_row in csv_data.iterrows():
        row = dict()
        for column in json_data["columns"].keys():
            if column in ["team", "rank"]:
                row[json_data['columns'][column]] = str(csv_row[column])
            else:
                row[json_data['columns'][column]] = str(f"{csv_row[f'{column}_med']} [{csv_row[f'{column}_25']}-{csv_row[f'{column}_75']}]")
        csv_data_list.append(row)

    # Load template
    with options.template_file.open("r") as fd:
        lines: List[str] = fd.read()

    # Substitute
    lines: List[str] = re.sub("##DATA##", str(csv_data_list), lines)
    lines: List[str] = re.sub("##COLUMNS##", str(columns).replace('"', ""), lines)
    lines: List[str] = re.sub("##ISASCENDING##", str(is_ascending).replace('"', "").replace("True", "true").replace("False", "false"), lines)
    lines: List[str] = re.sub("##TASKNUMBER##", str(options.task_number), lines)
    lines: List[str] = re.sub("##TITLE##", str(json_data["name"]), lines)

    for i in range(1, 4):
        lines: List[str] = re.sub(
            f"##STATUS{i}##",
            "active" if i == options.task_number else "inactive",
            lines,
        )

    # Write output
    with options.output_file.open("w") as fd:
        fd.write(lines)


if __name__ == "__main__":
    parser: argparse.ArgumentParser = argparse.ArgumentParser()
    parser.add_argument("--task_number", type=int, help="Task number")
    parser.add_argument("--input_csv", type=Path, help="input csv file")
    parser.add_argument("--input_json", type=Path, help="input json file")
    parser.add_argument("--output_file", type=Path, help="output html file")
    parser.add_argument("--template_file", type=Path, help="template html file")
    options: argparse.Namespace = parser.parse_args()
    main(options)
